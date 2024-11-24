require 'test/unit'
require 'field'

class FieldTestCase < Test::Unit::TestCase

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
        define_method("test_from_text#{index + 1}") do
            field = Field.from_text(text)
            assert_equal(text.strip, field.to_s)
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
        define_method("test_from_text_raises_argument_error#{index + 1}") do
            assert_raises(ArgumentError) do
                Field.from_text(text)
            end
        end
    end

    [
        [1, 1, <<~'EOS'],
            *
        EOS
        [2, 1, <<~'EOS'],
            **
        EOS
        [1, 2, <<~'EOS'],
            *
            *
        EOS
        [2, 2, <<~'EOS'],
            **
            **
        EOS
    ].each.with_index do |(width, height, text), index|
        define_method("test_size_#{index + 1}") do
            field = Field.from_text(text)
            assert_equal [width, height], [field.width, field.height]
        end
    end

    [
        [[[0, 0]], <<~'EOS'],
            *
        EOS
        [[[0, 0], [1, 0]], <<~'EOS'],
            **
        EOS
        [[[0, 0], [0, 1]], <<~'EOS'],
            *
            *
        EOS
    ].each.with_index do |(points, text), index|
        define_method("test_points_#{index + 1}") do
            field = Field.from_text(text)
            assert_equal points, field.points
        end
    end

    def test_toggle_methods
        field = Field.from_text('*')
        expected = [Field::TOGGLE_5, Field::TOGGLE_9]
        assert_equal expected, field.toggle_methods
    end

    [
        [true, <<~'EOS'],
            _
        EOS
        [false, <<~'EOS'],
            *
        EOS
        [true, <<~'EOS'],
            __
        EOS
        [false, <<~'EOS'],
            _*
        EOS
        [false, <<~'EOS'],
            *_
        EOS
        [true, <<~'EOS'],
            _
            _
        EOS
        [false, <<~'EOS'],
            _
            *
        EOS
        [false, <<~'EOS'],
            *
            _
        EOS
        [true, <<~'EOS'],
            __
            __
        EOS
        [false, <<~'EOS'],
            _*
            __
        EOS
        [false, <<~'EOS'],
            __
            *_
        EOS
        [false, <<~'EOS'],
            __
            _*
        EOS
    ].each.with_index do |(solved, text), index|
        define_method("test_solved_#{index + 1}") do
            field = Field.from_text(text)
            assert_equal solved, field.solved?
        end
    end

    [
        [Field::TOGGLE_5, 0, 0, <<~'EOS', <<~'EOS'],
            *
        EOS
            _
        EOS
        [Field::TOGGLE_9, 0, 0, <<~'EOS', <<~'EOS'],
            *
        EOS
            _
        EOS
        [Field::TOGGLE_5, 0, 0, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            __*
            _**
            ***
        EOS
        [Field::TOGGLE_5, 0, 1, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            _**
            __*
            _**
        EOS
        [Field::TOGGLE_5, 0, 2, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            ***
            _**
            __*
        EOS
        [Field::TOGGLE_5, 1, 0, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            ___
            *_*
            ***
        EOS
        [Field::TOGGLE_5, 1, 1, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            *_*
            ___
            *_*
        EOS
        [Field::TOGGLE_5, 1, 2, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            ***
            *_*
            ___
        EOS
        [Field::TOGGLE_5, 2, 0, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            *__
            **_
            ***
        EOS
        [Field::TOGGLE_5, 2, 1, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            **_
            *__
            **_
        EOS
        [Field::TOGGLE_5, 2, 2, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            ***
            **_
            *__
        EOS
        [Field::TOGGLE_9, 0, 0, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            __*
            __*
            ***
        EOS
        [Field::TOGGLE_9, 0, 1, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            __*
            __*
            __*
        EOS
        [Field::TOGGLE_9, 0, 2, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            ***
            __*
            __*
        EOS
        [Field::TOGGLE_9, 1, 0, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            ___
            ___
            ***
        EOS
        [Field::TOGGLE_9, 1, 1, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            ___
            ___
            ___
        EOS
        [Field::TOGGLE_9, 1, 2, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            ***
            ___
            ___
        EOS
        [Field::TOGGLE_9, 2, 0, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            *__
            *__
            ***
        EOS
        [Field::TOGGLE_9, 2, 1, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            *__
            *__
            *__
        EOS
        [Field::TOGGLE_9, 2, 2, <<~'EOS', <<~'EOS'],
            ***
            ***
            ***
        EOS
            ***
            *__
            *__
        EOS
    ].each.with_index do |(toggle_method, x, y, expected, text), index|
        define_method("test_touch_#{index + 1}") do
            field = Field.from_text(text)
            field.touch(toggle_method, x, y)
            expected = Field.from_text(expected)
            assert_equal expected, field
        end
    end

    def test_touch_with_invalid_toggle_method
        field = Field.from_text('*')
        assert_raises(ArgumentError) do
            field.touch(:invalid_toggle_method, 0, 0)
        end
    end

end

