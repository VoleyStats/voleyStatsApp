import SwiftUI

struct TeamCard: View{
    
    var team: Team
    var deleteTap: ()->()
    @State var deleteDialog: Bool = false
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 15, style: .continuous).fill(team.color)
                .overlay(Image("Voleibol")
                    .opacity(0.4).scaleEffect(0.2).offset(x: 300, y: 120))
            
                
            VStack(alignment: .leading){
                VStack{
                    Text("\(team.name)".uppercased()).font(.custom("Futura-bold", size: 56))
//                    Text("\(team.orgnization)").font(.caption)
                }.padding()
                HStack{
                    VStack(spacing: 15){
                        HStack{
                            Image(systemName: "person.3.fill")
                            Text("\(team.players().count) "+"players".trad())
                        }
                        HStack{
                            Image("Match").resizable().aspectRatio(1, contentMode: .fit).frame(width: 25)
                            Text("\(team.matches().count) "+"matches".trad())
                        }
                    }.padding().frame(maxWidth: .infinity, alignment: .leading)
//                    if team.pass{
//                        Image(systemName: "ticket.fill").resizable().aspectRatio(contentMode: .fit).rotationEffect(.degrees(-20))
//                            .frame(width: 50, height: 50).padding().background(Color.swatch.dark.high).clipShape(Circle()).foregroundStyle(.cyan)
//                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading).padding()
            
        }
        .clipped()
        .frame(height: 200)
        .overlay(Image(systemName: "multiply").onTapGesture {
            deleteTap()
        }.padding(), alignment: .topTrailing)
        
        .padding()
        
        
    }
}

//struct TeamCard_Previews: PreviewProvider {
//    static var previews: some View {
//        Text("no preview")
////        TeamCard(name:"alevin femenino", players: 11, matches: 6, color: .orange)
//    }
//}
