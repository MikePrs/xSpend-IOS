//
//  GoalWidgetLiveActivity.swift
//  GoalWidget
//
//  Created by Mike Paraskevopoulos on 18/7/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GoalWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GoalWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GoalWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GoalWidgetAttributes {
    fileprivate static var preview: GoalWidgetAttributes {
        GoalWidgetAttributes(name: "World")
    }
}

extension GoalWidgetAttributes.ContentState {
    fileprivate static var smiley: GoalWidgetAttributes.ContentState {
        GoalWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GoalWidgetAttributes.ContentState {
         GoalWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GoalWidgetAttributes.preview) {
   GoalWidgetLiveActivity()
} contentStates: {
    GoalWidgetAttributes.ContentState.smiley
    GoalWidgetAttributes.ContentState.starEyes
}
