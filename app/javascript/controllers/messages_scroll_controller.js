import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages-scroll"
export default class extends Controller {
  connect() {
    this.scrollToBottom()
  }

  scrollToBottom() {
    // Scroll to the bottom of the messages container
    this.element.scrollTop = this.element.scrollHeight
  }

  // Can be called when new messages arrive
  scrollOnNewMessage() {
    // Small delay to ensure content is rendered
    requestAnimationFrame(() => {
      this.scrollToBottom()
    })
  }
}
