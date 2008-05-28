class User < ActiveRecord::Base

  hobo_user_model

  fields do
    username :string, :login => true, :name => true
    email_address :email_address
    administrator :boolean, :default => false
    timestamps
  end

  set_admin_on_first_user
  
  has_many :owned_projects, :class_name => "Project", :foreign_key => "owner_id"
  
  has_many :project_memberships, :dependent => :destroy
  has_many :projects, :through => :project_memberships
  
  has_many :task_assignments, :dependent => :destroy
  has_many :tasks, :through => :task_assignments
  

  # --- Hobo Permissions --- #

  # It is possible to override the permission system entirely by
  # returning true from super_user?
  # def super_user?; true; end

  def creatable_by?(creator)
    !administrator? || creator.administrator?
  end

  def updatable_by?(updater, new)
    updater.administrator?
  end

  def deletable_by?(deleter)
    deleter.administrator?
  end

  def viewable_by?(viewer, field)
    true
  end


  # --- Fallback permissions --- #

  # (Hobo checks these for models that do not define the *_by? methods)

  def can_create?(obj)
    false
  end

  def can_update?(obj, new)
    false
  end

  def can_delete?(obj)
    false
  end

  def can_view?(obj, field)
    true
  end

end
