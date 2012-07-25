class ArticlesController < ApplicationController
  before_filter :require_login, :except => [:index, :show]

  def index
    @articles = Article.only(params)
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @current_user = current_user
    @article = Article.new(params[:article])
    if @article.save
      redirect_to @article, :notice => "Successfully saved article"
    else
      render :action => "new"
    end
    audit @article.inspect
  end

  def destroy
    @article = Article.find(params[:id])

    @article.destroy

    redirect_to articles_path
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update_attributes(params[:article])

    flash[:message] = "Article '#{@article.title}' Updated!"

    redirect_to article_path(@article)
  end
end
