require 'rails_helper'

RSpec.describe Image, type: :model do
  # Association test
  
  # Validation tests
  # ensure columns title, visibility, picture and created_by are present before saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:picture) }
  # visibility requires another test to validate either public or private 
  # it { should validate_presence_of(:visibility) }
  it { should validate_presence_of(:created_by) }
end
