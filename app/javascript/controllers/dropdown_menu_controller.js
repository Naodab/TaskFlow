import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["menu", "expand", "shrink", "dropdown"]

    connect() {
        this.menuTarget.addEventListener("click", this.toggleMenu.bind(this))
        window.addEventListener("click", this.windowToggleMenu.bind(this))
    }

    disconnect() {
        this.menuTarget.removeEventListener("click", this.toggleMenu.bind(this))
        window.removeEventListener("click", this.windowToggleMenu.bind(this))
    }

    toggleMenu() {
        this.expandTarget.classList.toggle("hidden")
        this.shrinkTarget.classList.toggle("hidden")
        this.dropdownTarget.classList.toggle("hidden")
    }

    windowToggleMenu(event) {
        if (!this.menuTarget.contains(event.target) && !this.dropdownTarget.classList.contains("hidden")) {
            this.toggleMenu(event)
        }
    }

}
