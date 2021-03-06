class ActionOfficer < ActiveRecord::Base
  extend  SoftDeletion::Collection
  include SoftDeletion::Record

  has_paper_trail

  validates_format_of :email,:with => Devise::email_regexp
  validates_format_of :group_email,:with => Devise::email_regexp, :allow_blank =>true
  validates :deputy_director_id, presence: true
  validates :press_desk_id, presence: true

  has_many :action_officers_pqs
  has_many :pqs, :through => :action_officers_pqs

  belongs_to :deputy_director
  belongs_to :press_desk

  before_validation WhitespaceValidator.new

  def self.by_name(name)
    active.where("name ILIKE ?","%#{name}%")
  end

  def emails
    if group_email.blank?
      self[:email]
    else
      "#{self[:email]};#{self[:group_email]}"
    end
  end

  def name_with_div
    if deputy_director.nil?
      name
    else
      "#{name} (#{deputy_director.division.name})"
    end
  end
end
