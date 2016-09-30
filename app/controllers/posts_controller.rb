class PostsController < ApplicationController
  before_filter :authenticate_user!,  only: [:edit, :update, :destroy, :create, :new, :my]
  before_action :set_post,            only: [:edit, :update, :destroy, :show]
  before_action :test_perm,           only: [:edit, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.published.ordered.paginate(page: params[:page], per_page: APP_CONFIG.blogs_per_page)
  end

  # GET /my
  def my
    @posts = Post.by_owner(current_user).ordered.paginate(page: params[:page], per_page: APP_CONFIG.blogs_per_page)
    render action: 'index'
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post         = Post.new(post_params)
    @post.user_id = current_user.id
    @post.email   = current_user.email

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by_id(params[:id])
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404 unless @post.present?
    end

    def test_perm
      redirect_to root_path unless @post.user_id == current_user.id
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:published, :title, :body, :preview)
    end
end
