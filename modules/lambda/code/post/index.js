'use strict';
var AWS = require('aws-sdk')
AWS.config.update({region: 'us-west-2'})

var dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = function (event, context, callback) {
    const message = JSON.parse(event.body);
    console.log(message);
    
    if(message !== '')
    {

        var params = {
            TableName: process.env.TABLE_NAME,
            Item: {
                TeamId: message.TeamId,
                TeamName: message.TeamName,
                Points: message.Points
            }

        }

        dynamo.put(params, function(err, data){
            if (err) {
                console.log("Error", err);
                callback( null, {
    
                    statusCode: 500,
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: {
                        message: JSON.stringify(err.message)
                    }
                });
            } else {
                callback(null, {
                    statusCode: 201,
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(params.Item)
                })
            }

        });
    }
    else
    {
        callback( null, {
    
            statusCode: 500,
            headers: {
                "Content-Type": "application/json"
            },
            body: {
                message: JSON.stringify({errorMessage: "El body del request no puede estar vacio"})
            }
        });
    }
   
}