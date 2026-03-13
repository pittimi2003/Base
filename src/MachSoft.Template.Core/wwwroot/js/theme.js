window.machsoftTheme = (() => {
  const storageKey = "mx-theme";
  const dark = "dark";
  const light = "light";

  const normalize = (value) => (value === dark || value === light ? value : null);

  const getStoredTheme = () => {
    try {
      return localStorage.getItem(storageKey);
    } catch {
      return null;
    }
  };

  const setTheme = (value) => {
    const theme = normalize(value) ?? light;
    document.documentElement.setAttribute("data-mx-theme", theme);
    try {
      localStorage.setItem(storageKey, theme);
    } catch {
      // no-op for storage restricted contexts
    }
    return theme;
  };

  const getPreferredTheme = () => {
    const stored = normalize(getStoredTheme());
    if (stored) {
      return stored;
    }

    const prefersDark = window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
    return prefersDark ? dark : light;
  };

  const init = () => setTheme(getPreferredTheme());
  return { init, setTheme, getPreferredTheme };
})();
