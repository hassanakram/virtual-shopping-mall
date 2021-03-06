class Product < ActiveRecord::Base

  PER_PAGE_SIZE = 12
  paginates_per PER_PAGE_SIZE

  attr_accessible :body, :price, :title, :images_attributes

  validates :title, presence: true, length: { maximum: 40 }
  validates :price, presence: true

  has_many :images, as: :imageable, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :order_items
  has_many :orders, through: :order_items
  belongs_to :user

  accepts_nested_attributes_for :images, allow_destroy: true

  scope :ordered, order('created_at DESC')

  define_index do
    indexes title
    indexes body

    set_property delta: true
    has user_id, created_at, updated_at
  end

  def self.perform_search(options = {})
    search_params = default_search_options(options)
    Product.search(options[:search_query], search_params)
  end

  def self.default_search_options(options)
    {
      with: {},
      include: :images,
      order: "created_at DESC",
      page: options[:page],
      per_page: PER_PAGE_SIZE,
    }
  end


end
