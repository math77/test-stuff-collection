import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { DeployFunction } from 'hardhat-deploy/types'
import fs from 'fs'

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts()
  const { deploy } = hre.deployments
  //const FieldGenerator = await hre.ethers.getContract('FieldGenerator')
  const ShapeGenerator = await hre.ethers.getContract('ShapeGenerator')
  const ColorGenerator = await hre.ethers.getContract('ColorGenerator')
  //const ShieldBadgeSVGs = await hre.ethers.getContract('ShieldBadgeSVGs')

  await deploy('Collection', {
    from: deployer,
    args: [ShapeGenerator.address, ColorGenerator.address],
    log: true,
    autoMine: true, // speed up deployment on local network (ganache, hardhat), no effect on live networks
    maxFeePerGas: hre.ethers.BigNumber.from('95000000000'),
  })
}
export default func
func.id = 'deploy_Collection' // id required to prevent reexecution
// Question: Should this be renamed to Shields?
func.tags = ['Collection']
