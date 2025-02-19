//
//  ContentView.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 2/1/24.
//

import SwiftUI

struct ContentView:View{
    @State var network = NetworkMonitor()
    @StateObject var path = PathManager()
    @State var activeSeason:String? = UserDefaults.standard.string(forKey: "season")
    @State var seasonName: String = "\("season".trad()) \(Date.now.formatted(.dateTime.year()))-\(Calendar.current.date(byAdding: .year, value: 1, to: Date.init())?.formatted(.dateTime.year()) ?? Date.now.formatted(.dateTime.year()))"
//    init(){
////        path.path.append(ListTeams(viewModel: ListTeamsModel()))
//    }
    var body: some View {
        NavigationStack(path: $path.path){
            ZStack(alignment: .bottomTrailing){
                ListTeams(viewModel: ListTeamsModel())
                if (activeSeason == nil){
                    ZStack{
                        Color.black.opacity(0.7)
                        VStack{
                            ZStack{
                                Text("name.season".trad()).font(.title2).frame(maxWidth: .infinity, alignment: .center)
                            }.padding().font(.title)
                            
                            VStack(alignment: .leading){
                                TextField("season".trad(), text: $seasonName).textFieldStyle(TextFieldDark())
                            }.padding()
                            Text("save".trad()).padding().frame(maxWidth: .infinity).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                UserDefaults.standard.set(seasonName, forKey: "season")
                                activeSeason = seasonName
                            }
                        }.padding().foregroundStyle(.white).background(Color.swatch.dark.mid).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity, maxHeight: .infinity).padding()
                    }
                }
            }
        }.environmentObject(network).environmentObject(path)
    }
}
