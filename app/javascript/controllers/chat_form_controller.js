import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-form"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log("Chat form controller connected")
  }

  handleKeydown(event) {
    if (event.key === "Enter") {
      // For text fields (not textarea), prevent default Enter behavior
      if (this.inputTarget.tagName.toLowerCase() === "input") {
        event.preventDefault()
      }

      // Submit on Shift+Enter for both input and textarea
      if (event.shiftKey) {
        event.preventDefault()

        // Submit the form
        this.element.requestSubmit()

        // Clear the input after submission
        this.inputTarget.value = ""
      }
    }
  }
}
