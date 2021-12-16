class Packet

  attr_accessor :bits
  attr_accessor :version
  attr_accessor :type_id
  attr_accessor :length_type_id

  attr_accessor :body_bits
  attr_accessor :packet_length
  attr_accessor :literal_value

  attr_accessor :sub_packets

  def initialize(bits)
    self.sub_packets = []
    self.bits = bits
    parse
  end

  def parse
    self.version = bits[0..2].to_i(2)
    self.type_id = bits[3..5].to_i(2)

    if type_id == 4
      self.body_bits = bits[6..]
      parse_literal
    else
      self.length_type_id = bits[6].to_i(2)
      self.body_bits = bits[7..]
      parse_op0 if length_type_id == 0
      parse_op1 if length_type_id == 1
    end
  end

  def version_sum
    sub_packets.sum(&:version_sum) + version
  end

  def operate
    case type_id
    when 0
      return sub_packets.map(&:operate).inject(:+)
    when 1
      return sub_packets.map(&:operate).inject(:*)
    when 2
      return sub_packets.map(&:operate).min
    when 3
      return sub_packets.map(&:operate).max
    when 4
      return literal_value
    when 5
      return sub_packets[0].operate > sub_packets[1].operate ? 1 : 0
    when 6
      return sub_packets[0].operate < sub_packets[1].operate ? 1 : 0
    when 7
      return sub_packets[0].operate == sub_packets[1].operate ? 1 : 0
    end
  end

  def parse_literal
    packet_bits, remaining_bits = body_bits.chars.each_slice(5).slice_when { |b| b[0] == "0" }.to_a

    self.packet_length = packet_bits.flatten.join.length + 6
    self.literal_value = packet_bits.each { |c| c.shift(1) }.flatten.join.to_i(2)
  end

  def parse_op0
    sub_packet_length = body_bits[0..14].to_i(2)
    packet_bits = body_bits[15..(15 + sub_packet_length - 1)]

    while packet_bits.length > 0
      p = Packet.new(packet_bits)
      packet_bits.slice!(0, p.packet_length)
      self.sub_packets << p
    end

    self.packet_length = sub_packet_length + 15 + 7
  end

  def parse_op1
    sub_packet_count = body_bits[0..10].to_i(2)
    packet_bits = body_bits[11..]

    sub_packet_count.times do
      p = Packet.new(packet_bits)
      packet_bits.slice!(0, p.packet_length)
      self.sub_packets << p
    end

    self.packet_length = sub_packets.sum(&:packet_length) + 11 + 7
  end

end

input = File.read('input.txt')
bits = input.chars.map { |c| c.hex.to_s(2).rjust(4, '0') }.join

p = Packet.new(bits)
pp p.version_sum
pp p.operate
