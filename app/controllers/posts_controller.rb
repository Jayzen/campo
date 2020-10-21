class PostsController < ApplicationController
  before_action :require_sign_in
  before_action :set_post, except: [:create]
  before_action :check_edit_permission, only: [:update, :trash]

  def show
    render 'update'
  end

  def create
    @post = Current.user.posts.new post_params

    # lock for post number generate
    Topic.with_advisory_lock("topic_#{@post.topic_id}_create_post") do
      if @post.save
        @post.topic.update activated_at: Time.now.utc
        PostNotificationJob.perform_later(@post)
        render 'create'
      else
        render 'update_form'
      end
    end
  end

  def update
    @post.edited_user =  Current.user
    @post.edited_at = Time.now

    if @post.update post_params
      render 'update'
    else
      render 'update_form'
    end
  end

  def reply
  end

  def trash
    @post.trash
  end

  private

  def post_params
    params.require(:post).permit(:topic_id, :reply_to_post_id, :body)
  end

  def set_post
    @post = Post.find params[:id]
  end

  def check_edit_permission
    unless @post.user == Current.user or Current.user.admin?
      redirect_to topic_url(@post.topic, number: @post.number), alert: t('flash.you_have_no_permissions')
    end
  end
end
