Dynamic-Map-for-Visualising-Trajectories-of-the-Public-Transport
=================================================================================

## Introduction
In order to help governors improve the public transport in Dublin (such as monitoring public transport, controlling delays and meditating congestions), we designed this interface which can be used for visualising trajectories of the buses containing series of GPS coordinates and their statistic locations at a certain time. The layout the interface is separated into two parts, aligned horizontally. The dynamic map of bus data showing movement and status of buses lies on the left hand side, while on the right there are three line charts with a time synchronising line showing the data corresponding to that time.

## Dynamic Bus Map
The background map of the main body is a road map of Dublin from OpenStreetMap. Points with three different colours are used for marking different status of the buses: on schedule (green), delayed (red), and congested (orange). The representations of delays and congestions on map are using larger points for prominence. Users can switch between real-time mode and accumulated mode on the top left corner of the interface.

The bottom control bar allows users to start, pause, and reset the playing process. It also allows users to change the frame rate for better observation. The “prev” or “next” buttons can be useful when users are interested in a certain time period and hope to play frame by frame. Functions are also provided in the drop down menu to users to choose to only show buses by a certain operator, a certain line, or even an individual bus. Users are also able to choose to see the bus locations in congestion or buses delayed only in another drop down
menu.

## Line Charts
The line charts lie on the right side of the interface. It consists of three line charts: the top one showing number of congestions, the middle one showing average time of delay, and the bottom one showing number of delays. An interesting innovation here is that we put a time synchronising line over the charts to show the current time with the map time bar running. The time synchronising line may help users explore the real-time status of the buses.

## System Requirement
The interface runs in Processing 2.2.1. The giCentre library is required. Some modifications have been made on the original datasets to fit the data input format of the interface. The modified dataset and the giCentre library are included in the zip file.

## Conclusion
In general, the interface provided can be useful for the governments and bus companies to observe the Dublin public traffic and develop improvement strategies. However, it is still limited on exploring the spatial cluster patterns of the city buses. This can be a promising
direction for the future work.
