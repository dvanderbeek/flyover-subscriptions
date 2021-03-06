module FlyoverSubscriptions
  module ActsAsSubscriber
    def acts_as_subscriber(options = {})
      include FlyoverSubscriptions::ActsAsSubscriber::InstanceMethods
      has_one :subscription, as: :subscriber, class_name: "FlyoverSubscriptions::Subscription", dependent: :destroy
      accepts_nested_attributes_for :subscription
    end

    module InstanceMethods
      def has_subscription?
        self.subscription.present? && !self.subscription.archived?
      end

      def cancel_subscription(at_period_end)
        self.subscription.cancel_stripe_subscription(at_period_end)
      end

      def flyover_subscription_plan
        nil
      end
    end
  end
end

ActiveRecord::Base.extend FlyoverSubscriptions::ActsAsSubscriber