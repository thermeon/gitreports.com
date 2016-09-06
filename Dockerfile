FROM ruby:2.2.0

# Install Rails build requirements
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Build the rails app
ENV INSTALL_PATH /gitreports
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
ADD Gemfile $INSTALL_PATH/Gemfile
ADD Gemfile.lock $INSTALL_PATH/Gemfile.lock
RUN bundle install --without development test

# Set Rails to run in production
ENV RAILS_ENV production
ENV RACK_ENV production

# Copy the main application
ADD . $INSTALL_PATH
VOLUME ["$INSTALL_PATH/public"]

# Precompile Rails assets
RUN bundle exec rake assets:precompile