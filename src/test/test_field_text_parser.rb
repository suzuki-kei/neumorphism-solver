require 'test/unit'
require 'field_text_parser'

class FieldTextParserTestCase < Test::Unit::TestCase

    [
        <<~'EOS',
            *
        EOS
        <<~'EOS',
            _
        EOS
        <<~'EOS',
            **
            **
        EOS
        <<~'EOS',
            *_
            _*
        EOS
        <<~'EOS',
            __
            __
        EOS
        <<~'EOS',
            *_*
            _*_
            *_*
        EOS
    ].each.with_index do |text, index|
        define_method("test_parse_with_valid_text_#{index + 1}") do
            expected = text.lines.map(&:strip).map(&:chars)
            actual = FieldTextParser.new.parse(text)
            assert_equal(expected, actual)
        end
    end

    [
        <<~'EOS',
        EOS
        <<~'EOS',
            +
        EOS
        <<~'EOS',
            *
            __
        EOS
    ].each.with_index do |text, index|
        define_method("test_parse_with_invalid_text_#{index + 1}") do
            assert_raises(ArgumentError) do
                FieldTextParser.new.parse(text)
            end
        end
    end

end

