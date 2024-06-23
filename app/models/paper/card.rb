# frozen_string_literal: true

class Paper::Card < Paper
  FIELDS = %i[ name reading company division title tel mobile email zip_code address url qr ]
  jsonb_accessor :attrs,
                 Hash[*FIELDS.map { |f| [f, :string] }.flatten]

end
