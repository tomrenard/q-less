class AddPhotoLinkToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :photo_link, :string
  end
end
