import Foundation

var bossHealth = 700
var bossDamage = 70
var bossDefence: String? = nil
var heroesHealth = [290, 270, 250, 300, 400, 250, 350, 280]
var heroesDamage = [25, 15, 10, 0, 5, 20, 0, 30]
var heroesAttackType = ["Physical", "Magical", "Kinetic", "Medic", "Golem", "Lucky", "Witcher", "Thor"]
let medicHealing = 40
var roundNumber = 0
var bossStunned = false
var witcherRevived = false

func main() {
    showStatistics()
    while !isGameOver() {
        round()
    }
}

func isGameOver() -> Bool {
    if bossHealth <= 0 {
        print("Герои победили!!!")
        return true
    }

    let allHeroesDead = heroesHealth.allSatisfy { $0 <= 0 }
    if allHeroesDead {
        print("Босс выиграл!!")
        return true
    }

    return false
}

func round() {
    roundNumber += 1
    chooseBossDefence()
    if !bossStunned {
        bossAttacks()
    } else {
        print("Босс ошеломлен и пропускает этот раунд!")
        bossStunned = false
    }
    medicHeals()
    heroesAttack()
    showStatistics()
}

func chooseBossDefence() {
    let randomIndex = Int.random(in: 0..<heroesAttackType.count)
    bossDefence = heroesAttackType[randomIndex]
}

func heroesAttack() {
    for i in 0..<heroesHealth.count {
        if heroesHealth[i] > 0 && bossHealth > 0 && heroesAttackType[i] != "Medic" && heroesAttackType[i] != "Witcher" {
            var damage = heroesDamage[i]
            if bossDefence == heroesAttackType[i] {
                let coeff = Int.random(in: 2...10)
                damage *= coeff
                print("КРИТИЧЕСКИЙ УРОН!!!!: \(heroesAttackType[i]) \(damage)")
            }

            bossHealth = max(0, bossHealth - damage)

            if heroesAttackType[i] == "Thor", Bool.random() {
                bossStunned = true
                print("Thor оглушил босса!")
            }
        }
    }
}

func bossAttacks() {
    var totalDamageToDistribute = bossDamage

    if heroesHealth[4] > 0 {
        let golemDamageShare = bossDamage / 5
        totalDamageToDistribute -= golemDamageShare * (heroesHealth.count - 1)
        heroesHealth[4] -= golemDamageShare * (heroesHealth.count - 1)
        print("Golem получает \(golemDamageShare * (heroesHealth.count - 1)) damage")
        heroesHealth[4] = max(0, heroesHealth[4])
    }

    for i in 0..<heroesHealth.count {
        if heroesHealth[i] > 0 && heroesAttackType[i] != "Golem" {
            var damageToHero = bossDamage

            if heroesAttackType[i] == "Lucky", Bool.random() {
                damageToHero = 0
                print("Lucky увернулся от атаки!!")
            }

            heroesHealth[i] = max(0, heroesHealth[i] - damageToHero)
        }
    }
}

func medicHeals() {
    if heroesHealth[3] > 0 {
        var minHealthIndex: Int? = nil
        var minHealth = Int.max

        for i in 0..<heroesHealth.count {
            if i != 3, heroesHealth[i] > 0, heroesHealth[i] < minHealth, heroesHealth[i] < 100 {
                minHealth = heroesHealth[i]
                minHealthIndex = i
            }
        }

        if let index = minHealthIndex {
            heroesHealth[index] += medicHealing
            print("Medic лечит \(heroesAttackType[index]) на \(medicHealing) жизни")
        }
    }
}

func showStatistics() {
    print("ROUND \(roundNumber) ----------------")
    print("Boss health: \(bossHealth) damage: \(bossDamage) defence: \(bossDefence ?? "None")")
    for i in 0..<heroesHealth.count {
        print("\(heroesAttackType[i]) health: \(heroesHealth[i]) damage: \(heroesDamage[i])")
    }
}

main()
