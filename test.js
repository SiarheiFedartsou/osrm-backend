const CheapRuler = require('cheap-ruler');
const vincenty = require('node-vincenty');
const turf = require('turf');

function swap(coord) {
    return [coord[1], coord[0]];
}

const source = [80, 80];
const destination = [0, 80];
const gt = vincenty.distVincenty(source[0], source[1], destination[0], destination[1]).distance;
const base = 8882574.6;
console.log( Math.abs(8905559 - gt));
const ruler = new CheapRuler((source[0] + destination[0]) / 2, 'meters');
console.log( Math.abs(gt - 8882574));





/**
 * 
 *     Scenario: Approximated Latitudinal distances at longitude 80
        Given the node locations
            | node | lat | lon |
            | a    | 80  | 80  |
            | b    | 0   | 80  |

        And the ways
            | nodes |
            | ab    |

        When I route I should get
            | from | to | route | distance       |
            | a    | b  | ab,ab | 8882574.6m ~0.1% |
 */

// const origin = [1, 1];
// const zoom = 10 * 0.8990679362704610899694577444566908445396483347536032203503E-5;
// const tableCoordToLonLat = (ci, ri) => {
//     return [origin[0] + ci * zoom, origin[1] - ri * zoom];
// }
// const ruler = new CheapRuler(origin[1], 'meters');
// let offseted = ruler.offset(origin, 10000, 0);
// console.log(offseted);
// const ruler2 = new CheapRuler((origin[1] + offseted[1])/2, 'meters');
// console.log(ruler2.distance(origin, offseted));
// // offseted = tableCoordToLonLat(100, 0);
// // console.log(ruler.distance(origin, offseted));
// // console.log(turf.distance(origin, offseted, 'meters'));
