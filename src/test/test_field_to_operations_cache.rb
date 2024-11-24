require 'test/unit'
require 'field_to_operations_cache'

class FieldToOperationsCacheTestCase < Test::Unit::TestCase

    def test_generate
        cache = FieldToOperationsCache.new
        cache.generate(2, 2, 4)

        assert_nil cache[Field.from_text(<<~'EOS')]
            *
        EOS
        assert_nil cache[Field.from_text(<<~'EOS')]
            *
        EOS
        assert_nil cache[Field.from_text(<<~'EOS')]
            **
        EOS
        assert_nil cache[Field.from_text(<<~'EOS')]
            *
            *
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            **
            **
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            **
            *_
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            **
            _*
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            **
            __
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            *_
            **
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            *_
            *_
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            *_
            __
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            _*
            **
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            _*
            *_
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            _*
            _*
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            _*
            __
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            __
            **
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            __
            *_
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            __
            _*
        EOS
        assert_not_nil cache[Field.from_text(<<~'EOS')]
            __
            __
        EOS
    end

end

