class CommentsController < ApplicationController
  before_action :authenticate_user!,  only: [:update, :destroy, :create]
  before_action :set_comment,         only: [:update, :destroy]

  # POST /comments
  def create
     @comment, @comment.user_id, @comment.email = Comment.new(comment_params), current_user.id, current_user.email
     @comment.save if Post.exists?(@comment.post_id)

     redirect_to_referer
  end

  # POST /comments/1
  def update
    @comment.update(comment_params) if @comment.perm_edit?(current_user)
    redirect_to_referer
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    redirect_to_referer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comment).permit(:post_id, :body)
    end
end
