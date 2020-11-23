class Profile::PostsController < Profile::BaseController
  def index
    #campo default topic被删除，显示对应的post会报错,报id显示错误
    #@posts = @user.posts.order(id: :desc).page(params[:page])
    @posts = @user.posts.includes(:topic).where(topics: { deleted_at: nil }).order(id: :desc).page(params[:page])
  end
end
