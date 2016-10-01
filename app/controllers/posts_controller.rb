class PostsController < ApplicationController
  before_filter :authenticate_user!,  only: [:edit, :update, :destroy, :create, :new, :my]
  before_action :set_post,            only: [:edit, :update, :destroy, :show]
  before_action :test_perm,           only: [:edit, :update, :destroy]

  # GET /posts
  def index
    if params[:tag]
      @posts = Post.published.tagged_with(params[:tag]).paginate(page: params[:page], per_page: APP_CONFIG.blogs_per_page)
    else
      @posts = Post.published.ordered.paginate(page: params[:page], per_page: APP_CONFIG.blogs_per_page)
    end

  end

  # GET /my
  def my
    @posts = Post.by_owner(current_user).ordered.paginate(page: params[:page], per_page: APP_CONFIG.blogs_per_page)
    render action: 'index'
  end

  # GET /posts/1
  def show
    @comment = Comment.new
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
    new_date = parse_date_time(params[:date])

    @post.attributes = post_params
    @post.created_at = new_date if new_date <= DateTime.now

    if @post.save
      redirect_to_referer
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  def tag_cloud
    @tags = Post.tag_counts_on(:tags)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by_id(params[:id])
      if @post.present?
        @comments = @post.comments.order(id: :desc).paginate(page: params[:page], per_page: APP_CONFIG.comments_per_page)
      else
        render file: "#{Rails.root}/public/404.html", layout: false, status: 404 unless @post.present?
      end
    end

    def test_perm
      redirect_to root_path unless @post.user_id == current_user.id
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:published, :title, :body, :preview, :tag_list)
    end
end
