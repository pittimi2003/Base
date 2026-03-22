document.addEventListener('click', async event => {
    const trigger = event.target.closest('[data-copy-target]');
    if (!trigger) {
        return;
    }

    const command = trigger.getAttribute('data-copy-target');
    if (!command) {
        return;
    }

    try {
        await navigator.clipboard.writeText(command);
        const previous = trigger.textContent;
        trigger.textContent = 'Copiado';
        window.setTimeout(() => {
            trigger.textContent = previous;
        }, 1200);
    } catch {
        trigger.textContent = 'No disponible';
        window.setTimeout(() => {
            trigger.textContent = 'Copiar';
        }, 1200);
    }
});
