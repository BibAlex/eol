# NOTE #perform is for resque to pick it up, e.g.: Resque.enque(PrepareAndSendNotifications)
# Also, @queue must be a class variable with the Resque queue name to work in.
# Code taken (kinda) from http://railscasts.com/episodes/271-resque
class PrepareAndSendNotifications
  @queue = :notifications

  def self.perform
    PendingNotification.send_notifications(:immediately)
    
    if (NotificationEmailerSettings.last_daily_emails_sent + 24.hours) < Time.now
      PendingNotification.send_notifications(:daily)
      NotificationEmailerSettings.last_daily_emails_sent = Time.now
    end
    
    if (NotificationEmailerSettings.last_weekly_emails_sent + 1.week) < Time.now
      PendingNotification.send_notifications(:weekly)
      NotificationEmailerSettings.last_weekly_emails_sent = Time.now
    end
  end
end