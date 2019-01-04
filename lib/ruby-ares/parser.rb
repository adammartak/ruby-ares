# encoding: utf-8

require 'nokogiri'
require 'ruby-ares/subject'

module RubyARES
  class Parser

    class ARESDatabaseError < StandardError; end
    class ParseError < StandardError; end

    def self.get_subject(xml)
      begin
        doc = parse_document(xml)

        # Basic info
        if doc.at_xpath('//D:VBAS')
          # Attributes of the subject
          @status = get_content(doc, '//D:VBAS/D:ROR/D:SOR/D:SSU')
          @ic = get_content(doc, '//D:VBAS/D:ICO')
          @dic = get_content(doc, '//D:VBAS/D:DIC')
          @name = get_content(doc, '//D:VBAS/D:OF')
          @legal_form = get_content(doc, '//D:VBAS/D:PF/D:NPF')
          @legal_form_id = get_content(doc, '//D:VBAS/D:PF/D:KPF')
          @updated_at = get_content(doc, 'D:ADB')

          place = get_content(doc, '//D:SZ/D:SD/D:T')
          record = get_content(doc, '//D:SZ/D:OV')
          section, insert = record.split if record

          @case_reference = RubyARES::CaseReference.new(place, section, insert)
        end

        # Corresponding addresses
        @addresses = find_addresses(doc)
      rescue
        raise ParseError, "Can't parse the given document."
      end

      if doc.at_xpath('//D:E')
        raise ARESDatabaseError, 'ARES returned an error.'
      end

      # Create and return subject
      RubyARES::Subject.new(@ic, @dic, @name, @status, @addresses, @updated_at, @legal_form, @legal_form_id, @case_reference)
    end

    protected

      def self.find_addresses(doc)
        @addresses = []

        if doc.at_xpath('//D:AA')
          id = get_content(doc, '//D:AA/D:IDA')
          street = get_content(doc, '//D:AA/D:NU')
          postcode = get_content(doc, '//D:AA/D:PSC')
          city = get_content(doc, '//D:AA/D:N')
          city_part = get_content(doc, '//D:AA/D:NCO')
          house_number = get_content(doc, '//D:AA/D:CD')
          house_number_type = get_content(doc, '//D:AA/D:TCD')
          orientational_number = get_content(doc, '//D:AA/D:CO')

          @addresses << RubyARES::Address.new(
            id, street, postcode, city, city_part,
            house_number, house_number_type, orientational_number
          )
        end

        @addresses
      end

      def self.parse_document(xml)
        Nokogiri::XML(xml)
      end

      def self.get_content(node, selector)
        content = node.at_xpath(selector)

        content.text if content
      end
  end
end
