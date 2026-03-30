const togglePassword = document.querySelector("#togglePassword");
  const password = document.querySelector("#password");

  togglePassword.addEventListener("click", function () {
    // toggle input type
    const type = password.getAttribute("type") === "password" ? "text" : "password";
    password.setAttribute("type", type);

    // toggle eye icon
    this.classList.toggle("fa-eye-slash");
  });

// logout button 
document.getElementById("logoutBtn")?.addEventListener("click", function () {
  if (confirm("Are you sure you want to logout?")) {
    window.location.href = "/logout"; // call Flask route
  }
});

      // Mobile sidebar toggle
      const closeBtn = document.getElementById("close-btn");
      const sidebar = document.querySelector("aside");

      if (closeBtn) {
        closeBtn.addEventListener("click", function () {
          sidebar.classList.toggle("show");
        });
      }

