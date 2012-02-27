class Season
  include MongoMapper::Document

  key :year, Integer

  many :teams

end
