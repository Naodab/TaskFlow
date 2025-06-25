import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["box"];
  static values = { timeout: Number };

  connect() {
    this.timeoutId = setTimeout(() => this.close(), this.timeoutValue);
  }

  close() {
    clearTimeout(this.timeoutId);
    this.boxTarget.remove();
  }
}
