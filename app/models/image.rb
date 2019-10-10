class Image < ApplicationRecord
    has_one_attached :picture

    # TODO validate the presence of image 
    # validations - ensures that title and created_by are provided and that visibility must be set to either public or private
     validates_presence_of :title, :created_by, :picture
     validates :visibility, :inclusion => { :in => %w(public private), :message => "%{value} must be public or private" }
end
