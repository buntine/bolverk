class Bolverk::Operations::Rotate < Bolverk::Operations::Base

  map_to "1010"

  parameter_layout [ [:register, 4], [:ignored, 4], [:rotation, 4] ]

  # ROTATES the value stored in "register", "rotation" times in a circular fashion.
  #
  # Example:
  #   A502 => 1010010100000010 => Rotate the value stored in register 5, 2 times.
  def execute
  end

end
