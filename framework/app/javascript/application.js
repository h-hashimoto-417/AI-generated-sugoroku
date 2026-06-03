// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", () => {
  const overlay = document.getElementById("loading-overlay");

  document.querySelectorAll("button[data-loading='ai']").forEach((btn) => {
    btn.addEventListener("click", () => {
      overlay.classList.remove("hidden");
    });
  });
});