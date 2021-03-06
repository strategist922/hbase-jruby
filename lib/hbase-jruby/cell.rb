class HBase
# Boxed Ruby class for org.apache.hadoop.hbase.KeyValue
# @!attribute [r] java
#   @return [org.apache.hadoop.hbase.KeyValue]
class Cell
  attr_reader :java

  # Creates a boxed object for a KeyValue object
  # @param [org.apache.hadoop.hbase.KeyValue] key_value
  def initialize key_value
    @java = key_value
    @ck   = nil
  end

  # Returns the rowkey of the cell decoded as the given type
  # @param [Symbol] type The type of the rowkey.
  #   Can be one of :string, :symbol, :fixnum, :float, :short, :int, :bigdecimal, :boolean and :raw.
  # @return [String, byte[]]
  def rowkey type = :string
    Util.from_bytes type, @java.getRow
  end

  # Returns the ColumnKey object for the cell
  # @return [ColumnKey]
  def column_key
    @ck ||= ColumnKey.new @java.getFamily, @java.getQualifier
  end

  # Returns the name of the column family of the cell
  # @return [String]
  def family
    String.from_java_bytes @java.getFamily
  end
  alias cf family

  # Returns the column qualifier of the cell
  # @param [Symbol] type The type of the qualifier.
  #   Can be one of :string, :symbol, :fixnum, :float, :short, :int, :bigdecimal, :boolean and :raw.
  # @return [Object]
  def qualifier type = :string
    Util.from_bytes type, @java.getQualifier
  end
  alias cq qualifier

  # Returns the timestamp of the cell
  # @return [Fixnum]
  def timestamp
    @java.getTimestamp
  end
  alias ts timestamp

  # Returns the value of the cell as a Java byte array
  # @return [byte[]]
  def value
    @java.getValue
  end
  alias raw value

  # Returns the column value as a String
  # @return [String]
  def string
    Util.from_bytes :string, value
  end
  alias str string

  # Returns the column value as a Symbol
  # @return [Symbol]
  def symbol
    Util.from_bytes :symbol, value
  end
  alias sym symbol

  # Returns the column value as a Fixnum
  # @return [Fixnum]
  def fixnum
    Util.from_bytes :fixnum, value
  end
  alias long fixnum

  # Returns the column value as a BigDecimal
  # @return [BigDecimal]
  def bigdecimal
    Util.from_bytes :bigdecimal, value
  end

  # Returns the column value as a Float
  # @return [Float]
  def float
    Util.from_bytes :float, value
  end
  alias double float

  # Returns the column value as a boolean value
  # @return [true, false]
  def boolean
    Util.from_bytes :boolean, value
  end
  alias bool boolean

  # Implements column key order
  # @param [Cell] other
  # @return [Fixnum] -1, 0, or 1
  def <=> other
    KeyValue.COMPARATOR.compare(@java, other.java)
  end

  # Returns a printable version of this cell
  # @return [String]
  def inspect
    %[#{cf}:#{cq} = "#{string}"@#{ts}]
  end
end#Cell
end#HBase

