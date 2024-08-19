# frozen_string_literal: true

namespace :decidim do
  namespace :decidim_guest_meeting_registration do
    task :choose_target_plugins do
      ENV["FROM"] = "#{ENV.fetch("FROM", nil)},decidim_guest_meeting_registration"
    end
  end
end

Rake::Task["decidim:choose_target_plugins"].enhance do
  Rake::Task["decidim:decidim_guest_meeting_registration:choose_target_plugins"].invoke
end
