(function () {
    var buttons = document.querySelectorAll('[data-copy-command]');
    if (!buttons.length || !navigator.clipboard) {
        return;
    }

    Array.prototype.forEach.call(buttons, function (button) {
        button.addEventListener('click', function () {
            var command = button.getAttribute('data-copy-command');
            navigator.clipboard.writeText(command).then(function () {
                var original = button.textContent;
                button.textContent = 'Copiado';
                window.setTimeout(function () {
                    button.textContent = original;
                }, 1200);
            });
        });
    });
}());
