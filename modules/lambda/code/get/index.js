'use strict';
var AWS = require("aws-sdk");

AWS.config.update({
  region: "us-west-2"
});

var dynamo = new AWS.DynamoDB.DocumentClient();


exports.handler = function (event, context, callback) {
    var id = event.queryStringParameters.id;
    console.log(event.queryStringParameters);
    
    // Create the DynamoDB service object
var ddb = new AWS.DynamoDB({apiVersion: '2012-08-10'});

    var params = {
    TableName: process.env.TABLE_NAME,
    Key: {
            'TeamId': {N: id}
        },
    //ProjectionExpression: 'TeamId'
    };

    ddb.getItem(params, function(err, data) {
        if (err) {
            console.error("Unable to read item. Error JSON:", JSON.stringify(err, null, 2));
            callback( null, {

                statusCode: 500,
                headers: {
                    "Content-Type": "application/json"
                },
                body: {
                    message: JSON.stringify(err, null, 2)
                }
            });
        } else {
            console.log("GetItem succeeded:", JSON.stringify(data, null, 2));
            callback(null, {
                statusCode: 200,
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(data, null, 2)
                });
        }
    });


}