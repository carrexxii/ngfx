type CubeMapFlag* = distinct uint8
const
    positiveX* = CubeMapFlag 0x00
    negativeX* = CubeMapFlag 0x01
    positiveY* = CubeMapFlag 0x02
    negativeY* = CubeMapFlag 0x03
    positiveZ* = CubeMapFlag 0x04
    negativeZ* = CubeMapFlag 0x05

