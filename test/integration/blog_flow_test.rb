require 'test_helper'

class BlogFlowTest < ActionDispatch::IntegrationTest
  test 'can see the welcome page' do
    get '/'
    assert_select 'title', 'TestBlog'
  end

  test 'create post flow' do
    get '/posts/new'
    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_select 'label', 'Email'

    post '/users/sign_in', params: { user: { email: 'user@user.ru', password: '111111' } }
    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select 'a', 'New Post'

    get '/posts/new'
    assert_response :success

    post '/posts', params: { post: { title:     'not public post',
                                     preview:   'test post preview',
                                     body:      'test post body',
                                     published: false,
                                     tag_list:  'tag1 tag2' } }

    assert_response :redirect
    get '/'

    assert_no_match /not public post/, response.body

    post '/posts', params: { post: { title:     'public post',
                                     preview:   'test post preview 2',
                                     body:      'test post body 2',
                                     published: true,
                                     tag_list:  'tag3 tag4' } }
    assert_response :redirect
    post_url = URI.parse(response.redirect_url).path
    post_id = post_url.scan( /\d+\Z/ ).first.to_i

    get '/'
    assert_select 'h3', 'public post'

    get post_url
    assert_select 'h1', 'public post'

    post '/comments', params: { comment: { post_id: post_id, body: 'test comment' } },
         headers: {'HTTP_REFERER' => post_url }
    assert_response :redirect
    follow_redirect!

    assert_match /test comment/, response.body

    get '/tags/tag3'
    assert_response :success
    assert_select 'h3', 'public post'
  end
end
