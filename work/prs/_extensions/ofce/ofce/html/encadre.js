<script>
  /* === Encadrés preview === */
document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.callout-tip').forEach(function (el) {
    var btnOpen = document.createElement('button');
    btnOpen.className = 'enc-preview-btn enc-open-btn';
    btnOpen.textContent = '▼ Lire la suite\u2026';
    btnOpen.addEventListener('click', function () {
      el.classList.add('enc-expanded');
    });

    var btnClose = document.createElement('button');
    btnClose.className = 'enc-preview-btn enc-close-btn';
    btnClose.textContent = '▲ Réduire';
    btnClose.addEventListener('click', function () {
      el.classList.remove('enc-expanded');
    });

    var bodyContainer = el.querySelector('.callout-body-container');
    if (bodyContainer) {
      bodyContainer.insertAdjacentElement('afterend', btnClose);
      bodyContainer.insertAdjacentElement('afterend', btnOpen);
    } else {
      el.appendChild(btnOpen);
      el.appendChild(btnClose);
    }
  });
});
</script>
