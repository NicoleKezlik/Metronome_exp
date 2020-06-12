// /*
//  * Example plugin template
//  */
//
// jsPsych.plugins["try"] = (function() {
//
//     var plugin = {};
//
//     plugin.info = {
//         name: "try",
//         parameters: {
//             stimulus: {
//                 type: jsPsych.plugins.parameterType.FUNCTION, // BOOL, STRING, INT, FLOAT, FUNCTION, KEYCODE, SELECT, HTML_STRING, IMAGE, AUDIO, VIDEO, OBJECT, COMPLEX
//                 default: undefined
//             },
//             button: {
//                 type: jsPsych.plugins.parameterType.HTML_STRING,
//                 default:'<button id="tap-button"> Tap-- </button>'
//             }
//         }
//     }
//
//     plugin.trial = function(display_element, trial) {
//
//         //display buttons
//         var buttons = [];
//         buttons.push(trial.button_html);
//
//         html += '<div id="jspsych-plugin-try-btngroup">';
//         html += '<div class="jspsych-html-button-response-button" style="display: inline-block; margin:'+trial.margin_vertical+' '+trial.margin_horizontal+'" id="jspsych-html-button-response-button-' + 0 +'" data-choice="'+0+'">'+"str+'</div>';
//
//         // for (var i = 0; i < trial.choices.length; i++) {
//         //     var str = buttons[i].replace(/%choice%/g, trial.choices[i]);
//         //     html += '<div class="jspsych-html-button-response-button" style="display: inline-block; margin:'+trial.margin_vertical+' '+trial.margin_horizontal+'" id="jspsych-html-button-response-button-' + i +'" data-choice="'+i+'">'+str+'</div>';
//         // }
//         html += '</div>';
//
//
//         // var html1 = '<button>tap</button>';
//         html = '<button onclick="f()">tap</button>';
//         display_element.innerHTML =html;
//
//         function f()
//         {
//             alert("h");
//         }
//
//
//         return_val = trial.func();
//         end_trial();
//
//         // data saving
//         // var trial_data = {
//         //     parameter_name: 'parameter value'
//         // };
//
//
//
//         // end trial
//         jsPsych.finishTrial(trial_data);
//     };
//
//     return plugin;
// })();
