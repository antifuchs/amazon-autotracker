# An amazon delivery notification forwarding app for Heroku.

I order things from amazon sometimes, and I live in a neighborhood
where stuff occasionally gets stolen, so I want to automatically get a
notification when one of my outstanding orders gets delivered. The way
it works with amazon involves a lot of clicking though, and I want
this to work automatically. Hence, this app.

This thing is a heroku app that receives amazon shipment notification
emails that you forward it; it extracts the tracking number and then
sends that (and the package's title) to the
[@TrackThis](https://twitter.com/TrackThis) twitter account, which
will send you a DM whenever the package's status changes. Also,
there's a mobile app that shows you the status of all your packages.

Setting it up:

1. Follow [@TrackThis](https://twitter.com/TrackThis) on twitter and DM them something so you get an activation link.
2. With that twitter account, make your own twitter app on https://dev.twitter.com/apps, set it to have read&write&DM permissions and make your own access token (make sure you set perms before making your own access token).
3. Set the config env vars to these tokens as detailed in https://github.com/sferik/twitter#configuration
   ``` sh
heroku config:add TWITTER_OAUTH_TOKEN_SECRET=
heroku config:add TWITTER_OAUTH_TOKEN=
heroku config:add TWITTER_CONSUMER_SECRET=
heroku config:add TWITTER_CONSUMER_KEY=
   ```
4. Install the free CloudMailIn plugin into your heroku app: `heroku addons:add cloudmailin:developer`
5. Update the CloudMailIn settings: `heroku addons:open cloudmailin`
   * Set forwarding address to this app's target:
     `http://your-app-nnnn.herokuapp.com/`**amazon**
   * Set format to JSON
6. Deploy this app
7. Add an email filter. Gmail example:
   ```
   from:ship-confirm@amazon.com => forward to: (your cloudmailin address)
   ```

And you're done. Any amazon shipment confirmation email you get should
now ping you on twitter (or the mobile app). Yay!

## Contributing

If you have any additional package shipment parsers that you want to
contribute, or if there are any bugs (or you just want to clean up the
horrid mess in web.rb), feel free to send me a pull request, or open
an issue. I'd love to hear how this works for you!
