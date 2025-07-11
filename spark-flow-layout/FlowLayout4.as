package
{
import mx.core.ILayoutElement;

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;

public class FlowLayout4 extends LayoutBase
{
    //---------------------------------------------------------------
    //
    //  Class properties
    //
    //---------------------------------------------------------------
    
    //---------------------------------------------------------------
    //  horizontalGap
    //---------------------------------------------------------------
    
    private var _horizontalGap:Number = 6;
    
    public function set horizontalGap(value:Number):void
    {
        _horizontalGap = value;
        
        // We must invalidate the layout
        var layoutTarget:GroupBase = target;
        if (layoutTarget)
        {
            layoutTarget.invalidateSize();
            layoutTarget.invalidateDisplayList();
        }
    }
    
    //---------------------------------------------------------------
    //
    //  Class methods
    //
    //---------------------------------------------------------------
    
    override public function measure():void
    {
        var totalWidth:Number = 0;
        var totalHeight:Number = 0;

        // loop through the elements
        var layoutTarget:GroupBase = target;
        var count:int = layoutTarget.numElements;
        for (var i:int = 0; i < count; i++)
        {
            // get the current element, we're going to work with the
            // ILayoutElement interface
            var element:ILayoutElement = useVirtualLayout ? 
                layoutTarget.getVirtualElementAt(i) :
                layoutTarget.getElementAt(i);
            
            // In virtualization scenarios, the element returned could
            // still be null. Look at the typical element instead.
            if (!element)
                element = typicalLayoutElement;

            // Find the preferred sizes    
            var elementWidth:Number = element.getPreferredBoundsWidth();
            var elementHeight:Number = element.getPreferredBoundsHeight();
            
            totalWidth += elementWidth;
            totalHeight = Math.max(totalHeight, elementHeight);
        }
        if (count > 0)
            totalWidth += (count - 1) * _horizontalGap;
        
        layoutTarget.measuredWidth = totalWidth;
        layoutTarget.measuredHeight = totalHeight;
        
        // Since we really can't fit the content in space any
        // smaller than this, set the measured minimum size
        // to be the same as the measured size.
        // If the container is clipping and scrolling, it will
        // ignore these limits and will still be able to 
        // shrink below them.
        layoutTarget.measuredMinWidth = totalWidth;
        layoutTarget.measuredMinHeight = totalHeight; 
    }

    override public function updateDisplayList(containerWidth:Number,
                                               containerHeight:Number):void
    {
        // The position for the current element
        var x:Number = 0;
        var y:Number = 0;
        var maxWidth:Number = 0;
        var maxHeight:Number = 0;
        
        // loop through the elements
        var layoutTarget:GroupBase = target;
        var count:int = layoutTarget.numElements;
        for (var i:int = 0; i < count; i++)
        {
            // get the current element, we're going to work with the
            // ILayoutElement interface
            var element:ILayoutElement = useVirtualLayout ? 
                layoutTarget.getVirtualElementAt(i) :
                layoutTarget.getElementAt(i);
            
            // Resize the element to its preferred size by passing
            // NaN for the width and height constraints
            element.setLayoutBoundsSize(NaN, NaN);
            
            // Find out the element's dimensions sizes.
            // We do this after the element has been already resized
            // to its preferred size.
            var elementWidth:Number = element.getLayoutBoundsWidth();
            var elementHeight:Number = element.getLayoutBoundsHeight();
            
            // Would the element fit on this line, or should we move
            // to the next line?
            if (x + elementWidth > containerWidth)
            {
                // Start from the left side
                x = 0;
                
                // Move down by elementHeight, we're assuming all 
                // elements are of equal height
                y += elementHeight;
            }
            
            // Position the element
            element.setLayoutBoundsPosition(x, y);
            
            // Find maximum element extents. This is needed for
            // the scrolling support.
            maxWidth = Math.max(maxWidth, x + elementWidth);
            maxHeight = Math.max(maxHeight, y + elementHeight);
            
            // Update the current position, add the gap
            x += elementWidth + _horizontalGap;
        }
        
        // Scrolling support - update the content size
        layoutTarget.setContentSize(maxWidth, maxHeight);
    }
}
}