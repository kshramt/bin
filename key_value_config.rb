module ::KeyValueConfig
  INTEGER_REGEXP = /\A[-+]?[0-9]+\z/
  FLOAT_REGEXP = /\A[-+]?[0-9]*\.?[0-9]+([eEdDqQ][-+]?[0-9]+)?\z/

  module_function
  def load_file(path)
    load(File.read(path))
  end

  def load(str)
    Hash[str\
           .split("\n")\
           .map(&:strip)\
           .delete_if(&:empty?)\
           .map{|line|
             key, value = line.split(/\s+/, 2)
               [key, _parse_value(value.strip())]}]
  end

  def dump(h)
    h\
      .map{|k, v| "#{k}\t#{v}"}\
      .join("\n")
  end

  def _parse_value(str)
    case str.strip()
    when INTEGER_REGEXP
      str.to_i
    when FLOAT_REGEXP
      str.sub(/[dDqQ]/, 'e').to_f
    else
      str
    end
  end
end

if $PROGRAM_NAME == __FILE__
  require 'minitest/pride'
  require 'minitest/autorun'

  class Tester < ::MiniTest::Test
    def test__parse_value_integer
      assert(::KeyValueConfig._parse_value('0').integer?)
      assert_equal(::KeyValueConfig._parse_value('0'), 0)
      assert(::KeyValueConfig._parse_value('1').integer?)
      assert_equal(::KeyValueConfig._parse_value('1'), 1)
      assert(::KeyValueConfig._parse_value('-1').integer?)
      assert_equal(::KeyValueConfig._parse_value('-1'), -1)
      assert(::KeyValueConfig._parse_value('10').integer?)
      assert_equal(::KeyValueConfig._parse_value('10'), 10)
    end

    def test__parse_value_float
      assert_equal(::KeyValueConfig._parse_value('0.1'), 0.1)
      assert_equal(::KeyValueConfig._parse_value('1.1'), 1.1)
      assert_equal(::KeyValueConfig._parse_value('-1.1'), -1.1)
      assert_equal(::KeyValueConfig._parse_value('1.1e3'), 1100.0)
      assert_equal(::KeyValueConfig._parse_value('1e3'), 1000.0)
      assert_equal(::KeyValueConfig._parse_value('1e-3'), 0.001)
      assert_equal(::KeyValueConfig._parse_value('1.1d3'), 1100.0)
      assert_equal(::KeyValueConfig._parse_value('1.1q3'), 1100.0)
    end

    def test__parse_value_string
      assert_equal(::KeyValueConfig._parse_value('1.r3'), '1.r3')
      assert_equal(::KeyValueConfig._parse_value('1.qq3'), '1.qq3')
      assert_equal(::KeyValueConfig._parse_value('1 3'), '1 3')
    end

    def test_load
      assert_equal(::KeyValueConfig.load(<<-EOS), {'a' => 1, 'b' => 2.1, 'c' => 'd'})
 a 1
b 2.1
c d
      EOS
    end

    def test_dump
      assert_equal(::KeyValueConfig.dump({'a' => 1, 'b' => 2.1, 'c' => 'd'}), <<-EOS.chomp)
a	1
b	2.1
c	d
      EOS
    end

    def test_dump_and_load
      original_hash = {'a' => 1, 'b' => 2.1e8, 'c' => 'd'}
      str = ::KeyValueConfig.dump(original_hash)
      loaded_hash = ::KeyValueConfig.load(str)
      assert(loaded_hash, original_hash)
    end
  end
end
