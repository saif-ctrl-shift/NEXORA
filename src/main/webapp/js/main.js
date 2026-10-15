/**
 * NEXORA - Main Client Script
 * Lightweight helper utilities for interactive filtering and confirmation
 */

document.addEventListener("DOMContentLoaded", function () {
  // Auto-dismiss alerts after 5 seconds if desired
  const alerts = document.querySelectorAll(".alert");
  alerts.forEach(function (alert) {
    setTimeout(function () {
      alert.style.transition = "opacity 0.5s ease";
      alert.style.opacity = "0";
      setTimeout(function () {
        if (alert.parentNode) alert.parentNode.removeChild(alert);
      }, 500);
    }, 6000);
  });

  // Client-side quick filter for Organizer participant list
  const searchInput = document.getElementById("participantFilter");
  if (searchInput) {
    searchInput.addEventListener("input", function (e) {
      const term = e.target.value.toLowerCase();
      const rows = document.querySelectorAll(".participant-row");
      rows.forEach(function (row) {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(term) ? "" : "none";
      });
    });
  }
});
