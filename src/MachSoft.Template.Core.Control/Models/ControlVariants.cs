namespace MachSoft.Template.Core.Control.Models;

/// <summary>
/// Variantes exclusivas del catálogo Core.Control para acciones.
/// Se separa de Core para evitar colisión semántica con MxButtonVariant (Primary/Secondary/Tertiary/Danger).
/// </summary>
public enum MxControlButtonVariant
{
    Filled,
    Outlined,
    Text,
    Fab
}

public enum MxAlertVariant
{
    Neutral,
    Info,
    Success,
    Warning,
    Danger
}

public enum MxPopupPlacement
{
    BottomStart,
    BottomEnd,
    TopStart,
    TopEnd
}

public enum MxTooltipPlacement
{
    Top,
    Bottom,
    Left,
    Right
}

public enum MxAvatarSize
{
    XSmall,
    Small,
    Medium,
    Large,
    XLarge
}

public enum MxAvatarShape
{
    Circle,
    Rounded,
    Square
}

public enum MxChipVariant
{
    Neutral,
    Brand,
    Success,
    Warning,
    Danger
}
