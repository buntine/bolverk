class Bolverk::Operations::Rotate < Bolverk::Operations::Base

  map_to "1010"

  parameter_layout [ [:register, 4], [:ignored, 4], [:rotation, 4] ]

  # ROTATES the value stored in "register", "rotation" times in a circular fashion.
  #
  # Example:
  #   A502 => 1010010100000010 => Rotate the value stored in register 5, 2 times.
  def execute
    value = @emulator.register_read(@register)
    result = rotate(value, @rotation.binary_to_decimal)

    @emulator.register_write(@register, result)
  end

 private

  # Rotates a bitstring in a right-circular fashion.
  # Example: rotate("00001111", 2) => "11000011"
  def rotate(value, amount=1)
    result = value.clone

    amount.times do
      result.sub!(/^([01]{7})([01]{1})$/) { "#{$2}#{$1}" }
    end

    result
  end

end
