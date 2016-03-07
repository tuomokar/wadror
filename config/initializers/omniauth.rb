Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end

#7ac6e3e92980e976f3cb
# a14d58c4e2d903c4638bdd88152ad52ea59302a1