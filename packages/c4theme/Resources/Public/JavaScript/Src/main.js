jQuery(document).ready(function ($) {
 

  // Navbar Toggle Funktionalität (Mobile Menü)
  $(".navbar-toggle").on("click", function () {
    var target = $(this).attr("data-target") || $(this).data("target");
    var $collapse = $(target);
    if (!$collapse.length) return;

    $(this).toggleClass("collapsed");
    var isOpen = $collapse.hasClass("in");

    if (isOpen) {
      $collapse.slideUp(280, function () {
        $collapse.removeClass("in show");
      });
      $(this).attr("aria-expanded", "false");
    } else {
      $collapse.addClass("in show");
      $collapse.slideDown(280);
      $(this).attr("aria-expanded", "true");
    }
  });

  // Dropdown Caret Funktionalität
  $(".caret").on("click", function (e) {
    e.preventDefault();

    var $dropdown = $(this).closest(".dropdown");
    var $navEbeneZwei = $dropdown.find(".nav-ebene-zwei");

    // Schließe alle anderen Dropdowns
    $(".dropdown")
      .not($dropdown)
      .removeClass("open")
      .find(".nav-ebene-zwei")
      .slideUp(200);

    // Toggle aktuelles Dropdown
    $dropdown.toggleClass("open");
    $navEbeneZwei.slideToggle(200);

    // Toggle aria-expanded Attribut
    var $dropdownToggle = $(this).closest(".dropdown-toggle");
    var isExpanded = $dropdownToggle.attr("aria-expanded") === "true";
    $dropdownToggle.attr("aria-expanded", !isExpanded);
  });

  // Submenü Toggle bei Klick auf icon-arrow-down
  $(".menu__arrow, .icon-arrow-down").on("click", function (e) {
    e.preventDefault();
    e.stopPropagation();

    var $menuItem = $(this).closest("li");
    var $submenu = $menuItem.find("> ul");

    // Schließe alle anderen Submenüs
    $(".menu > li")
      .not($menuItem)
      .removeClass("open--sub-menu")
      .find("> ul")
      .slideUp(200);

    // Toggle aktuelles Submenü
    $menuItem.toggleClass("open--sub-menu");
    $submenu.slideToggle(200);
  });

  // Mobile Hamburger Menu Toggle
  $(".mobile-hamburger").on("click", function () {
    $("body").toggleClass("is-open-menu");

    // Toggle aria-expanded Attribut
    var isExpanded = $(this).attr("aria-expanded") === "true";
    $(this).attr("aria-expanded", !isExpanded);
  });
 
 
});

 

// Scroll-Funktionalität: Füge "is-scrolled" Klasse zum body hinzu wenn Scroll >= 100px
$(window).on("scroll", function () {
  if ($(window).scrollTop() >= 100) {
    $("body").addClass("is-scrolled");
  } else {
    $("body").removeClass("is-scrolled");
  }
});

// Prüfe auch beim Laden der Seite
if ($(window).scrollTop() >= 100) {
  $("body").addClass("is-scrolled");
}

// Video-Content: Beim Öffnen der Lightbox YouTube-URL setzen (Autoplay), beim Schließen pausieren/stoppen
$(document).on("shown.bs.modal", ".video-content__modal", function () {
  $(this).find("iframe[data-embed-url]").each(function () {
    var url = $(this).data("embed-url");
    if (url) this.src = url + (url.indexOf("?") >= 0 ? "&" : "?") + "autoplay=1";
  });
});
$(document).on("hidden.bs.modal", ".video-content__modal", function () {
  var $modal = $(this);
  $modal.find("video").each(function () {
    this.pause();
  });
  $modal.find("iframe[data-embed-url]").each(function () {
    this.src = "";
  });
});
